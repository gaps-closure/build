
#include <stdio.h>
#include <string>
#include <fstream>

#include <amqm/AMQManager.h>
#include <Utils.h>
#include "ImageReceiver.h"
#include <nlohmann/json.hpp>

#include <opencv2/opencv.hpp>
#include <heartbeat/HeartBeat.h>
#include <BlockingQueue.h>

using namespace amqm;
using namespace cms;
using namespace std;
using namespace cv;

#define OVERLAY(text,pos)  cv::putText(imageMat,text,pos,ENCLAVE_FONT,FONT_SCALE,ENCLAVE_COLOR,FONT_THICKNESS)

static const string WINDOW_NAME = "CLOSURE Image Receiver";
static const cv::Scalar ENCLAVE_COLOR = CV_RGB(235, 140, 52);
static const cv::HersheyFonts  ENCLAVE_FONT = cv::FONT_HERSHEY_DUPLEX;
static const cv::Point NAME_POINT(10, 400);
static const cv::Point SIZE_POINT(10, 440);
static const cv::Point META_POINT(10, 480);
static const double FONT_SCALE = 1.0;
static const int FONT_THICKNESS = 2;

static BlockingQueue<json> messageQueue;
static cv::Mat imageMat;

ImageReceiver::ImageReceiver()
{
    amq.listen("receiveImageDetections", std::bind(&ImageReceiver::updateImageDetected, this, _1), true);

    json j = Utils::loadDefaultConfig();
    processConfigContent(j);
}

void ImageReceiver::processConfigContent(json j)
{
}

ImageReceiver::~ImageReceiver()
{
}

void ImageReceiver::updateImageDetected(const json &j)
{
    messageQueue.push(j);
}

void hexToBin(string hexData, char *image_buf, int image_buf_size)
{
    int buf_size = hexData.length();
    if (image_buf_size < buf_size / 2) {
        cout << "ERROR: buffer too small: " << buf_size << " v.s. " << image_buf_size << endl;
        buf_size = image_buf_size * 2;
    }

    int k = 0;
    for (int i = 0; i < buf_size; i += 2) {
        image_buf[k++] = std::stoul(hexData.substr(i, 2), nullptr, 16);
    }
}

void displayImage(const json &j)
{
    string name = j["A_name"].get<string>();
    int size = j["B_size"];
    string pad = j["C_pad"].get<string>();
    string meta = j["D_metadata"].get<string>();
    string imageData = j["E_imgData"].get<string>();

    cout << "Receiver rcvd " << name << " : " << size << " : " << meta << endl;

    char img[size];
    hexToBin(imageData, img, size);

    vector<unsigned char> imVec(img, img + size);
    imdecode(imVec, IMREAD_COLOR, &imageMat);

    OVERLAY("Name: " + name, NAME_POINT);
    OVERLAY("Size: " + to_string(size), SIZE_POINT);
    OVERLAY("Meta: " + meta, META_POINT);

    imshow(WINDOW_NAME, imageMat);
    // GIve enough time for iamge to render, 800ms seems adequate
    waitKey(800); // Wait for any keystroke in the window
}

void displaySplash(string pathanme)
{
    std::string image_path = samples::findFile(pathanme);
    Mat img = imread(image_path, IMREAD_COLOR);
    if (img.empty()) {
        std::cout << "Could not read the image: " << image_path << std::endl;
        return;
    }
    img.convertTo(imageMat, CV_8U);

    imshow(WINDOW_NAME, imageMat);
    moveWindow(WINDOW_NAME, 0, 100);
    waitKey(1000); // Wait for any keystroke in the window
}

void ImageReceiver::run()
{
    displaySplash("config/images/splash-receiver.jpg");

    HeartBeat isrm_HB("ImageReceiver");
    isrm_HB.startup_Listener("ImageDetector");

    json timeout;
    timeout["A_name"] = "timeout";

    while (true) {
        json msg = messageQueue.pop(1, timeout);
        string name = msg["A_name"].get<string>();

        // imshow will not refresh the window after waitKey returns
        // refresh it if no new message is received
        if (!name.compare("timeout")) {
            imshow(WINDOW_NAME, imageMat);
            waitKey(10);
        }
        else {
            displayImage(msg);
        }
    }
}

