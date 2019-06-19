import React, { memo } from 'react';
import { Route } from 'react-router';
import PropTypes from 'prop-types';

import GroupLinks from 'components/Group/GroupLinks';
import ApplicationLayout from '../ApplicationLayout';

const GroupLayout = ({ component: Component, ...rest }) => (
  <div>
    <ApplicationLayout
      {...rest}
      position='static'
      component={matchProps => (
        <GroupLinks {...matchProps} />
      )}
    />
    <Component {...rest} />
  </div>
);

GroupLayout.propTypes = {
  component: PropTypes.elementType,
};

export default GroupLayout;
