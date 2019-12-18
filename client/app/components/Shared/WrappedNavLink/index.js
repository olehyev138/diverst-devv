import React from 'react';
import { NavLink } from 'react-router-dom';

// Wrap NavLink to fix ref issue temporarily until react-router-dom is updated to fix this
export default React.forwardRef((props, ref) => <NavLink innerRef={ref} {...props} />);