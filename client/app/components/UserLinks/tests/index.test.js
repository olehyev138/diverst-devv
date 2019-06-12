import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { unwrap } from '@material-ui/core/test-utils';

import { StyledUserLinks } from '../index';
const UserLinksNaked = unwrap(StyledUserLinks);

/**
 * TODO:
 *  - test correct actions are dispatched
 */

loadTranslation('./app/translations/en.json');

const props = {
  classes: {},
  pageTitle: {}
};

describe('<UserLinks />', () => {
  xit('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<UserLinksNaked {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });

  xit('Should render and match the snapshot', () => {
    const wrapper = shallowWithIntl(<UserLinksNaked {...props} />);

    expect(wrapper).toMatchSnapshot();
  });
});
