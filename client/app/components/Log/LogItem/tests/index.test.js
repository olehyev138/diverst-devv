/**
 *
 * Tests for Log Items
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
const { readdirSync } = require('fs');

const props = {
  activity: {}
};

// get all log models
const logItems = readdirSync('./app/components/Log/LogItem', { withFileTypes: true })
  .filter(dirent => dirent.isDirectory())
  .map(dirent => dirent.name);

let Component;

describe('LogItem', () => {
  logItems.forEach((model) => {
    // get each action in model and test the index
    readdirSync(`./app/components/Log/LogItem/${model}`, { withFileTypes: true })
      .filter(dirent => dirent.isDirectory())
      .map(dirent => dirent.name).forEach((action) => {
        // eslint-disable-next-line global-require
        Component = require(`components/Log/LogItem/${model}/${action}`).default;
        // test case
        it('Expect to not log errors in console', () => {
          const spy = jest.spyOn(global.console, 'error');
          const wrapper = shallow(<Component classes={{}} {...props} />);

          expect(spy).not.toHaveBeenCalled();
        });
      });
  });
});
