import React from 'react';
import { shallow } from 'enzyme';
import { unwrap } from '@material-ui/core/test-utils';
import 'utils/mockReactRouterHooks';

import { StyledAdminLinks } from 'components/Admin/AdminLinks/index';
const AdminLinksNaked = unwrap(StyledAdminLinks);

const props = {
  classes: {},
  drawerOpen: true,
  drawerToggleCallback: jest.fn(),
};

describe('<AdminLinks />', () => {
  it('should not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<AdminLinksNaked {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });

  it('should render and match the snapshot', () => {
    const wrapper = shallow(<AdminLinksNaked {...props} />);

    expect(wrapper).toMatchSnapshot();
  });
});
