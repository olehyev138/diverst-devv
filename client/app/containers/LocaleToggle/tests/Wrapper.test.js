import React from 'react';
// TODO: Commented out because 'enzyme' not found
// import { mount } from 'enzyme';
import { enzymeFind } from 'styled-components/test-utils';

import Wrapper from '../Wrapper';

describe('<Wrapper />', () => {
  /*
  it('should render an <div> tag', () => {
    const wrapper = mount(<Wrapper />);
    const renderedComponent = enzymeFind(wrapper, Wrapper);
    expect(renderedComponent.type()).toEqual('div');
  });

  it('should have a className attribute', () => {
    const wrapper = mount(<Wrapper />);
    const renderedComponent = enzymeFind(wrapper, Wrapper);
    expect(renderedComponent.prop('className')).toBeDefined();
  });

  it('should adopt a valid attribute', () => {
    const id = 'test';
    const wrapper = mount(<Wrapper id={id} />);
    const renderedComponent = enzymeFind(wrapper, Wrapper);
    expect(renderedComponent.prop('id')).toEqual(id);
  });

  it('should not adopt an invalid attribute', () => {
    const wrapper = mount(<Wrapper attribute='test' />);
    const renderedComponent = enzymeFind(wrapper, Wrapper);
    expect(renderedComponent.prop('attribute')).toBeUndefined();
  });
  */
});
