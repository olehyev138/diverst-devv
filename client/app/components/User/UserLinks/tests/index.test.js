import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { unwrap } from '@material-ui/core/test-utils';

import { ROUTES } from 'containers/Shared/Routes/constants';

import { MobileNavMenu, NavLinks, StyledUserLinks } from 'components/User/UserLinks/index';
const UserLinksNaked = unwrap(StyledUserLinks);

/**
 * TODO:
 *  - test correct actions are dispatched
 */

loadTranslation('./app/translations/en.json');

const mobileProps = {
  classes: {},
  mobileNavAnchor: {},
  isMobileNavOpen: true,
  handleMobileNavClose: jest.fn()
};

const navProps = {
  classes: {}
};

const props = {
  classes: {},
  pageTitle: 'Page Title'
};

describe('<UserLinks />', () => {
  describe('<MobileNavMenu />', () => {
    it('Expect to not log errors in console', () => {
      const spy = jest.spyOn(global.console, 'error');
      const wrapper = shallowWithIntl(<MobileNavMenu {...mobileProps} />);

      expect(spy).not.toHaveBeenCalled();
    });

    it('Should render and match the snapshot', () => {
      const wrapper = shallowWithIntl(<MobileNavMenu {...mobileProps} />);

      expect(wrapper).toMatchSnapshot();
    });
  });

  describe('<NavMenu />', () => {
    it('Expect to not log errors in console', () => {
      const spy = jest.spyOn(global.console, 'error');
      const wrapper = shallowWithIntl(<NavLinks {...navProps} />);

      expect(spy).not.toHaveBeenCalled();
    });

    it('Should render and match the snapshot', () => {
      const wrapper = shallowWithIntl(<NavLinks {...navProps} />);

      expect(wrapper).toMatchSnapshot();
    });
  });

  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<UserLinksNaked {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });

  it('Should render and match the snapshot', () => {
    const wrapper = shallowWithIntl(<UserLinksNaked {...props} />);

    expect(wrapper).toMatchSnapshot();
  });
});
