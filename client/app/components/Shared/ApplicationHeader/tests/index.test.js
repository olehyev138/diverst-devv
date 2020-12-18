import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { unwrap } from '@material-ui/core/test-utils';
import 'utils/mockReactRouterHooks';
import { intl } from 'tests/mocks/react-intl';

import { StyledApplicationHeader } from 'components/Shared/ApplicationHeader/index';

loadTranslation('./app/translations/en.json');
const ApplicationHeaderNaked = unwrap(StyledApplicationHeader);

/**
 * TODO:
 *   - test button clicks dispatch correct actions
 */

const props = {
  classes: {},
  user: {},
  drawerOpen: true,
  drawerToggleCallback: jest.fn(),
  enterprise: {},
  position: 'position',
  isAdmin: true,
  logoutBegin: jest.fn(),
  handleVisitAdmin: jest.fn(),
  handleVisitHome: jest.fn()
};

describe('<ApplicationHeader />', () => {
  it('should not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<ApplicationHeaderNaked intl={intl} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });

  it('should render and match the snapshot', () => {
    const wrapper = shallowWithIntl(<ApplicationHeaderNaked intl={intl} {...props} />);

    expect(wrapper).toMatchSnapshot();
  });
});
