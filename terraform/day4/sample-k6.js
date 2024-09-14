import http from 'k6/http';

export const options = {
  stages: [
    { duration: '30s', target: 300 },
    { duration: '2m', target: 1000 },
    { duration: '1m', target: 10 },
  ],
  noConnectionReuse: true,
  userAgent: 'MyK6UserAgentString/1.0',
};

export default function () {
  const url = `http://${__ENV.MY_HOSTNAME}/system`;
  const params = {
    headers: {
      'Host': 'linuxtips.mydomain.fake',
    },
  };
  http.get(url,params)
}
