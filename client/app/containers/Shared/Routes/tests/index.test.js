import React from 'react';
import { shallow } from 'enzyme/build';

import Routes from 'containers/Shared/Routes/index';

describe('<NotFoundPage />', () => {
  it('should not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<Routes />);

    expect(spy).not.toHaveBeenCalled();
  });
});
