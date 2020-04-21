/**
 * Test for backend routes
 */

import toJson from '../../internals/scripts/backendRoutes';
import { ROUTES } from 'containers/Shared/Routes/constants';
import fs from 'fs';

describe('Check if routes.json in the backend matches the frontend', () => {
  expect.extend({
    toBeValid(received, validator) {
      if (validator(received))
        return {
          message: () => '',
          pass: true
        };

      return {
        message: () => '\u001b[31m'
          + 'Backend assets/json/routes.json does not match the Routes/constant.js\n'
          + 'Please run `npm run rubyRoutes` to fix the issue'
          + '\u001b[0m',
        pass: false
      };
    }
  });

  it('should match', () => {
    const backendRoutes = fs.readFileSync('../app/assets/json/routes.json').toString('utf8');
    const frontEndRoutes = toJson(ROUTES);
    expect(backendRoutes).toBeValid(json => json === frontEndRoutes);
  });
});
