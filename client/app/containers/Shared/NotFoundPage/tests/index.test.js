import React from 'react';
import { shallow } from 'enzyme/build';
import { unwrap } from '@material-ui/core/test-utils/index';

import NotFoundPage from 'containers/Shared/NotFoundPage/index';
const NotFoundPageNaked = unwrap(NotFoundPage);

describe('<NotFoundPage />', () => {
  it('should not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<NotFoundPageNaked classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });

  it('should render and match the snapshot', () => {
    const wrapper = shallow(<NotFoundPageNaked classes={{}} />);

    expect(wrapper).toMatchSnapshot();
  });
});
