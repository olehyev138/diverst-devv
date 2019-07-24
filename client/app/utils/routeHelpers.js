
import dig from 'object-dig';
import { RouteContext } from 'containers/Layouts/ApplicationLayout';

/*
 * Provide an interface to the global routing data stored in RouteContext
 *
 *
 * routeContext looks like:
 *   {
 *     computedMatch: { params: { ... }}
 *     location: { ... }
 *   }
 *
 */
export default class RouteService {
  constructor(contextFunc) {
    this.contextFunc = contextFunc;
    this.routeData = this.contextFunc(RouteContext);
    this.match = this.routeData.computedMatch;
    this.location = this.routeData.location;
  }

  path() {
    return this.location.pathname;
  }

  params(...keys) {
    const params = [];
    for (const key of keys)
      params.push(dig(this.match, 'params', key));

    return params;
  }

  queries(...keys) {
    // todo: - return url query strings in location
    //       - parse with querystring library
  }
}
