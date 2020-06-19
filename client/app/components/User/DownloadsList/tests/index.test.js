/**
 *
 * Tests for DownloadsList
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { DownloadsList } from '../index';

const props = {
  downloadData: {},
  getUserDownloadDataBegin: jest.fn()
};
describe('<DownloadsList />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<DownloadsList classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
