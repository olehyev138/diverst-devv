
import dig from 'object-dig';
import { RouteContext } from 'containers/Layouts/ApplicationLayout';


/*
 * Provide an interface to the global routing data
 *
 *
 * routeContext looks like:
 *   {
 *     computedMatch: { params: { }}
 *     location: { ... }
 *   }
 *
 */
export default class RouteService {
  constructor(contextFunc) {
    this.contextFunc = contextFunc;
    this.routeParams = this.contextFunc(RouteContext);
    this.match = this.routeParams.computedMatch;
    this.location = this.location;
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
  }
}
