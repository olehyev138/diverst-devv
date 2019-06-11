import React from 'react';
import { render } from 'react-testing-library';
import { IntlProvider } from 'react-intl';

import ConnectedNotFoundPage, { NotFoundPage } from '../index';

describe('<NotFoundPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const dispatch = jest.fn();

    render(
      <IntlProvider locale='en'>
        <NotFoundPage />
      </IntlProvider>
    );

    expect(spy).not.toHaveBeenCalled();
  });


  xit('should render and match the snapshot', () => {
    const {
      container: { firstChild },
    } = render(
      <IntlProvider locale='en'>
        <NotFoundPage />
      </IntlProvider>,
    );
    expect(firstChild).toMatchSnapshot();
  });
});
