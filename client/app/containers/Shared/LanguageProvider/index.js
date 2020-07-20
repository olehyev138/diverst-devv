/*
 *
 * LanguageProvider
 *
 * this component connects the redux state language locale to the
 * IntlProvider component and i18n messages (loaded from `app/translations`)
 */

import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';
import { IntlProvider } from 'react-intl';

import { changeLocale } from 'containers/Shared/LanguageProvider/actions';

import { selectLocale } from './selectors';
import { selectCustomText } from 'containers/Shared/App/selectors';

import GlobalLanguageProvider from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';

import LocaleService from 'utils/localeService';
import { getLocaleObjectFromLocaleString, getLanguageStringFromLocaleObject, getLocaleStringFromLocaleObject } from 'utils/localeHelpers';

import { Settings, DateTime } from 'luxon';

export function LanguageProvider(props) {
  // Gets the browser locale
  const defaultBrowserLocale = DateTime.local() && DateTime.local().resolvedLocaleOpts() && DateTime.local().resolvedLocaleOpts().locale;
  // Get the Intl.Locale object using the current set locale, the browser locale if the locale isn't set, or falls back to en-US
  const userLocaleObject = getLocaleObjectFromLocaleString(LocaleService.getLocale() || defaultBrowserLocale || 'en-US');
  // Get the language string (Ex. 'en') from the locale object
  const userLanguage = getLanguageStringFromLocaleObject(userLocaleObject);
  // Get the locale string (Ex. 'en-US') from the locale object
  const userLocale = getLocaleStringFromLocaleObject(userLocaleObject);

  const messages = { ...props.messages[userLanguage] };

  useEffect(() => {
    // Set user locale
    if (userLocale && props.changeLocale) {
      props.changeLocale(userLocale);
      Settings.defaultLocale = userLocale;
    }
  }, [userLocale]);

  useEffect(() => {
    if (props.customTexts) // eslint-disable-next-line no-return-assign
      Object.keys(props.customTexts).forEach(key => messages[`diverst.texts.${key}`] = props.customTexts[key]);
  }, [props.customTexts]);

  return (
    <IntlProvider
      locale={userLanguage}
      key={userLanguage}
      messages={messages}
    >
      <GlobalLanguageProvider>
        {React.Children.only(props.children)}
      </GlobalLanguageProvider>
    </IntlProvider>
  );
}

LanguageProvider.propTypes = {
  locale: PropTypes.string,
  messages: PropTypes.object,
  children: PropTypes.element.isRequired,
  customTexts: PropTypes.object,
  changeLocale: PropTypes.func,
};

const mapStateToProps = createStructuredSelector({
  locale: selectLocale(),
  customTexts: selectCustomText(),
});

const mapDispatchToProps = {
  changeLocale,
};

export default memo(connect(
  mapStateToProps,
  mapDispatchToProps,
)(LanguageProvider));
