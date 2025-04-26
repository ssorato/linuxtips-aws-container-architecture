import http from 'k6/http';
import { check, sleep } from 'k6';

export let options = {
    stages: [
        { duration: '10s', target: 20 },   
        { duration: '60s', target: 50 },  
        { duration: '80s', target: 100 },
        { duration: '20s', target: 50 },
        { duration: '10s', target: 10 }
    ]
};

export default function () {
    let res = http.get('https://' + __ENV.MY_CHIP_URL + '/system'); 

    check(res, {
        'Status 200': (r) => r.status === 200,
        'Response time < 500ms': (r) => r.timings.duration < 500,
    });

    sleep(1); // Sleep betwen requests
}
