import React from 'react';
import { render } from 'react-testing-library';
import { FormattedMessage, defineMessages } from 'react-intl';
import { Provider } from 'react-redux';
import { browserHistory } from 'react-router-dom';

import ConnectedLanguageProvider, { LanguageProvider } from 'containers/Shared/LanguageProvider/index';
import configureStore from 'configureStore';
import { translationMessages } from 'i18n';

const messages = defineMessages({
  someMessage: {
    id: 'some.id',
    defaultMessage: 'This is some default message',
    en: 'This is some en message',
  },
});

jest.mock('containers/Shared/LanguageProvider/GlobalLanguageProvider', () => (
  function render() {
    return 'This is some default message';
  }
));

describe('<LanguageProvider />', () => {
  let store;

  beforeAll(() => {
    store = configureStore({}, browserHistory);
  });

  it('should render its children', () => {
    const children = <h1>Test</h1>;
    const { container } = render(
      <Provider store={store}>
        <LanguageProvider messages={messages} locale='en'>
          {children}
        </LanguageProvider>
      </Provider>,
    );

    expect(container.firstChild).not.toBeNull();
  });
});

describe('<ConnectedLanguageProvider />', () => {
  let store;

  beforeAll(() => {
    store = configureStore({}, browserHistory);
  });

  it('should render the default language messages', () => {
    const { queryByText } = render(
      <Provider store={store}>
        <ConnectedLanguageProvider messages={translationMessages}>
          <FormattedMessage {...messages.someMessage} />
        </ConnectedLanguageProvider>
      </Provider>,
    );
    expect(queryByText(messages.someMessage.defaultMessage)).not.toBeNull();
  });
});
