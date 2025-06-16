## Real-time, multiplayer cribbage
![gameplay screenshot](https://i.imgur.com/KdMFpMt.png)

### To setup prerequisites:
Start with fresh install of ubuntu 24.04 server with openssh enabled
* sudo chmod+x prereq.sh
* sudo ./prereq.sh

### To run cribbage.live locally:
* docker-compose up --build
* app runs at http://localhost:5000

### To run the tests
* docker-compose exec -T flask coverage run -m  pytest
* docker-compose exec -T flask coverage report -m
