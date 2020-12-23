/**
 *
 * Tests for TemplatesList
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { intl } from 'tests/mocks/react-intl';
import { TemplatesList } from '../index';

loadTranslation('./app/translations/en.json');

const props = {
  intl,
  customTexts: { erg: 'Group' },
  templates: [],
};

describe('<EmailLinks />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<TemplatesList intl={intl} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
