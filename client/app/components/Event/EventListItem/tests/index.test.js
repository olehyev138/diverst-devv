/**
 *
 * Tests for EventListItem
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { EventListItem } from '../index';

const props = {
  item: {},
};

describe('<EventListItem />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<EventListItem classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
