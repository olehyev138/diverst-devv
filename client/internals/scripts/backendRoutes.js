const { ROUTES } = require('../../app/containers/Shared/Routes/constants');
const fs = require('fs');

function routesPruner(routes) {
  const toReturn = {};

  for (const [key, value] of Object.entries(routes)) {
    if (typeof value === 'object') {
      const pruned = routesPruner(value);
      if (Object.keys(pruned).length > 0)
        toReturn[key] = pruned;
    } else if (typeof value === 'string') {
      if (key === 'path')
        return value;
    } else if (typeof value === 'function')
      if (key === 'path')
        return value();
  }

  return toReturn;
}

function toJson(routes) {
  return JSON.stringify(routesPruner(routes), null, '  ')
}

function main() {
  fs.writeFile('../app/assets/json/routes.json', toJson(ROUTES), (err) => {
    if (err)
      console.log(err);
    else
      console.log('Success');
  });
}

if (typeof require !== 'undefined' && require.main === module) {
  main();
}

module.exports = toJson