import React from 'react';
import { shallow } from 'enzyme';
import { unwrap } from '@material-ui/core/test-utils';
import 'utils/mockReactRouterHooks';

import { StyledUserLayout } from '../index';
const UserLayoutNaked = unwrap(StyledUserLayout);

/**
 * TODO:
 *  - test it accepts & renders a child component
 *  - test it renders AuthenticatedLayout as a child component
 *  - test it renders UserLinks as a child component
 */


const props = {
  classes: {},
  component: jest.fn(),
  pageTitle: {}
};

describe('<UserLayout />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<UserLayoutNaked {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });

  it('Should render and match the snapshot', () => {
    const wrapper = shallow(<UserLayoutNaked {...props} />);

    expect(wrapper).toMatchSnapshot();
  });
});
