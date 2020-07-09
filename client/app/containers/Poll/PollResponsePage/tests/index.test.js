import React from 'react';
import { shallow } from 'enzyme';
import { unwrap } from '@material-ui/core/test-utils';
import 'utils/mockReactRouterHooks';

import { PollResponsePage } from '../index';

/**
 * TODO:
 *  - test it accepts & renders a child component
 *  - test it renders ApplicationLayout as a child component
 *  - test it redirects if not authenticated
 */


const props = {
  classes: {},
  component: jest.fn()
};

describe('<AnonymousLayout />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<PollResponsePage {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });

  it('Should render and match the snapshot', () => {
    const wrapper = shallow(<PollResponsePage {...props} />);

    expect(wrapper).toMatchSnapshot();
  });
});
