function hello(req) {
  req.headersOut['Content-Type'] = 'text/plain';
  req.return(200, 'Hello there!');
}

export default {
  hello
}
