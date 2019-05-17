const argv = require('./argv');

module.exports = parseInt(argv.port || "8082" || '3000', 10);
