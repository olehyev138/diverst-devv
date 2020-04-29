import React from 'react';
import { Provider } from 'react-redux';
import { browserHistory } from 'react-router-dom';
import { shallow, mount } from 'enzyme';

import LocaleToggle, { mapDispatchToProps } from 'containers/Shared/LocaleToggle/index';
import { changeLocale } from 'containers/Shared/LanguageProvider/actions';
import LanguageProvider from 'containers/Shared/LanguageProvider/index';

import configureStore from 'configureStore';
import { translationMessages } from 'i18n';

describe('<LocaleToggle />', () => {
  let store;

  beforeAll(() => {
    store = configureStore({}, browserHistory);
  });

  xit('should render the default language messages', () => {
    const renderedComponent = shallow(
      <Provider store={store}>
        <LanguageProvider messages={translationMessages}>
          <LocaleToggle />
        </LanguageProvider>
      </Provider>,
    );
    expect(renderedComponent.contains(<LocaleToggle />)).toBe(true);
  });

  xit('should present the default `en` english language option', () => {
    const renderedComponent = mount(
      <Provider store={store}>
        <LanguageProvider messages={translationMessages}>
          <LocaleToggle />
        </LanguageProvider>
      </Provider>,
    );
    expect(renderedComponent.contains(<option value='en'>English</option>)).toBe(true);
  });

  describe('mapDispatchToProps', () => {
    describe('onLocaleToggle', () => {
      it('should be injected', () => {
        const dispatch = jest.fn();
        const result = mapDispatchToProps(dispatch);
        expect(result.onLocaleToggle).toBeDefined();
      });

      it('should dispatch changeLocale when called', () => {
        const dispatch = jest.fn();
        const result = mapDispatchToProps(dispatch);
        const locale = 'fr';
        const evt = { target: { value: locale } };
        result.onLocaleToggle(evt.target.value);
        expect(dispatch).toHaveBeenCalledWith(changeLocale(locale));
      });
    });
  });
});
