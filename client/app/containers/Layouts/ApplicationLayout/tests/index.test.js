import React from 'react';
import PropTypes from 'prop-types';
import { shallow } from 'enzyme';
import { unwrap } from '@material-ui/core/test-utils';

import ApplicationLayout from '../index';

/**
 * TODO:
 *  - test it accepts & renders a child component
 */


const props = {
  classes: {},
  component: jest.fn()
};

describe('<ApplicationLayout />', () => {
  ApplicationLayout.contextTypes = {
    router: PropTypes.object
  };

  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<ApplicationLayout {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });

  it('Should render and match the snapshot', () => {
    const wrapper = shallow(<ApplicationLayout {...props} />);

    expect(wrapper).toMatchSnapshot();
  });
});
