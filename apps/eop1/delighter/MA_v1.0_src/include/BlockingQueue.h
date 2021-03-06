/*
 * BlockingQueue.h
 *
 *  Created on: Feb 13, 2021
 *      Author: tchen
 */

#ifndef DELIGHTER_MA_V1_0_SRC_INCLUDE_BLOCKINGQUEUE_H_
#define DELIGHTER_MA_V1_0_SRC_INCLUDE_BLOCKINGQUEUE_H_

#include <mutex>
#include <condition_variable>
#include <deque>
#include <chrono>

template <typename T>
class BlockingQueue
{
private:
    std::mutex              d_mutex;
    std::condition_variable d_condition;
    std::deque<T>           d_queue;

public:
    void push(T const& value) {
        {
            std::unique_lock<std::mutex> lock(this->d_mutex);
            d_queue.push_front(value);
        }
        this->d_condition.notify_one();
    }

    T pop() {
        std::unique_lock<std::mutex> lock(this->d_mutex);
        this->d_condition.wait(lock, [=]{ return !this->d_queue.empty(); });
        T rc(std::move(this->d_queue.back()));
        this->d_queue.pop_back();
        return rc;
    }

    T pop(int timeout, T& obj) {
        std::unique_lock<std::mutex> lock(this->d_mutex);

        bool ok = this->d_condition.wait_for(lock, timeout*1000ms, [=]{ return !this->d_queue.empty(); });
        if (ok) {
            T rc(std::move(this->d_queue.back()));
            this->d_queue.pop_back();
            return rc;
        }
        else {
            return obj;
        }
    }
};

#endif /* DELIGHTER_MA_V1_0_SRC_INCLUDE_BLOCKINGQUEUE_H_ */
