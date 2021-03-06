#pragma once
#ifndef AMQ_H
#define AMQ_H
#include "MessageHandler.h"
#include <nlohmann/json.hpp>
#include <functional>
#include <unordered_map>
#include <thread>
using namespace std;
using json = nlohmann::json;
namespace amqm {
	class AMQManager {
	public:
		AMQManager() {
			activemq::library::ActiveMQCPP::initializeLibrary();
		}
		AMQManager(string uri) {
// tchen			this->brokerURI = uri;
                    name = uri;  // tchen
                    activemq::library::ActiveMQCPP::initializeLibrary();
		}

		void listen(string channelName, function< void(json j) > callback, bool topic) {
			if (running.find(channelName) == running.end()
				|| running[channelName] != true) {
				running[channelName] = true;
				std::thread t1(&AMQManager::startListening, this, channelName, callback, topic);
				t1.detach();
			}
                        printf("%s listening on channel: %s, topic: %s\n", name.c_str(), channelName.c_str(), topic ? "true" : "false"); 
		}

		void stopListening(const string& channelName) {
			running[channelName] = false;
		}

		void publish(const string &channelName, json data, bool topic) {
			ActiveMQConnectionFactory *connectionFactory = new ActiveMQConnectionFactory(brokerURI);

			Connection *connection = connectionFactory->createConnection();

			connection->start();

			Session *session = connection->createSession(Session::AUTO_ACKNOWLEDGE);
			Destination *destination;
			if (topic) {
				 destination = session->createTopic(channelName);
			}
			else {
				destination = session->createQueue(channelName);
			}
			MessageProducer *producer = producer = session->createProducer(destination);
			producer->setDeliveryMode(DeliveryMode::PERSISTENT);

			string text = (string)data.dump();
			TextMessage *message = session->createTextMessage(text);
                        message->setCMSCorrelationID(name);
			producer->send(message);

			delete message;
			delete destination;
			delete session;
			delete connection;
			delete connectionFactory;
		}

	private:
		void startListening(const string &channelName, function< void(json j) > callback, 
				const bool &topic) {
//                    MessageHandler consumer(brokerURI, channelName, callback, name + std::to_string(count++), topic, false);
                    MessageHandler consumer(brokerURI, channelName, callback, name, topic, false);
			consumer.runConsumer();
			while (running[channelName]) {}
		}
		string brokerURI = "failover:(tcp://127.0.0.1:61616)";
		unordered_map<string, bool> running;
                string name;
                int count = 1;
	};
}
#endif
