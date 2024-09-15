import http from 'k6/http';

export const options = {
  stages: [
    { duration: '3m', target: 3 },
    { duration: '10m', target: 3 },
    { duration: '3m', target: 0 },
  ],
  noConnectionReuse: true,
  userAgent: 'MyK6UserAgentString/1.0',
};

export default function () {
  const url = `http://${__ENV.MY_HOSTNAME}/burn/cpu`;
  const params = {
    headers: {
      'Host': 'linuxtips.mydomain.fake',
    },
  };
  http.get(url,params)
}
