import React from 'react';
import { shallow, mount } from 'enzyme';
import { IntlProvider, defineMessages } from 'react-intl';

import ToggleOption from '../index';

xdescribe('<ToggleOption />', () => {
  xit('should render default language messages', () => {
    const defaultEnMessage = 'someContent';
    const message = defineMessages({
      enMessage: {
        id: 'diverst.containers.LocaleToggle.en',
        defaultMessage: defaultEnMessage,
      },
    });
    const renderedComponent = shallow(
      <IntlProvider locale='en'>
        <ToggleOption value='en' message={message.enMessage} />
      </IntlProvider>,
    );
    expect(
      renderedComponent.contains(<ToggleOption value='en' message={message.enMessage} />),
    ).toBe(true);
  });

  xit('should display `value`(two letter language code) when `message` is absent', () => {
    const renderedComponent = mount(
      <IntlProvider locale='de'>
        <ToggleOption value='de' />
      </IntlProvider>,
    );
    expect(renderedComponent.text()).toBe('de');
  });
});
