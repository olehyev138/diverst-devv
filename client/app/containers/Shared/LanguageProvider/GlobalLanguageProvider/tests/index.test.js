/**
 *
 * Tests for GlobalLanguageProvider
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
const { GlobalLanguageProvider } = jest.requireActual('containers/Shared/LanguageProvider/GlobalLanguageProvider');
const props = {
  children: <p></p>
};
describe('<GlobalLanguageProvider />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<GlobalLanguageProvider classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
