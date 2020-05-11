import React from 'react';

export const renderChildrenWithProps = (children, props) => React.Children.map(children, child => React.cloneElement(child, { ...props }));
