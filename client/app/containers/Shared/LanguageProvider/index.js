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

import { Settings } from 'luxon';

export function LanguageProvider(props) {
  const messages = { ...props.messages[props.locale] };

  const userLocale = LocaleService.getLocale();

  useEffect(() => {
    // Set user locale
    if (userLocale) {
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
      locale={props.locale}
      key={props.locale}
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
