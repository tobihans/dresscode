class Constants {
  static const String apiUrl = 'https://dresscode-backend.herokuapp.com';
  static const String registerUrl = '$apiUrl/auth/user/register';
  static const String loginUrl = '$apiUrl/auth/login';
  static const String categoriesUrl = '$apiUrl/category';
  static const String productsUrl = '$apiUrl/product';
  static const String commentsUrl = '$apiUrl/comments';
  static const String wishlistUrl = '$apiUrl/wishlist';
  static const String cartUrl = '$apiUrl/cart';
  static const String currentUserUrl = '$apiUrl/auth/current';

  static const httpCodes = {
    200: 'OK',
    201: 'Created',
    202: 'Accepted',
    203: 'Non-Authoritative Information',
    204: 'No Content',
    205: 'Reset Content',
    206: 'Partial Content',
    226: 'Im Used',
    300: 'Multiple Choices',
    301: 'Moved Permanently',
    302: 'Temporary Redirect',
    303: 'See Other',
    304: 'Not Modified',
    305: 'Use Proxy',
    307: 'Temporary redirect',
    308: 'Permanent redirect',
    400: 'Bad Request',
    401: 'Unauthorized',
    402: 'Payment Required',
    403: 'Forbidden',
    404: 'Not Found',
    405: 'Method Not Allowed',
    406: 'Not Acceptable',
    407: 'Proxy Authentication Required',
    408: 'Request Time-Out',
    409: 'Conflict',
    410: 'Gone',
    411: 'Length Required',
    412: 'Precondition Failed',
    413: 'Request Entity Too Large',
    414: 'Request-URI Too Large',
    415: 'Unsupported Media Type',
    416: 'Range not satisfiable',
    417: 'Expectation failed',
    422: 'Unprocessable Entity',
    423: 'Locked',
    425: 'Too early',
    426: 'Upgrade required',
    428: 'Precondition required',
    429: 'Too many requests',
    431: 'Request header fields too large',
    451: 'Unavailable for legal reasons',
    500: 'Internal Server Error',
    501: 'Not Implemented',
    502: 'Bad Gateway',
    503: 'Service Unavailable',
    504: 'Gateway Timeout',
    505: 'HTTP Version Not Supported',
    506: 'Variant also negotiates',
    507: 'Insufficient Storage',
    508: 'Loop detected',
    510: 'Not extended',
    511: 'Network authentication required',
  };

  static const Map<String, String> emptyMap = {};
}
