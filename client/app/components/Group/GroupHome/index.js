/**
 *
 * Group Home Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import { Typography } from '@material-ui/core';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { FormattedMessage } from 'react-intl';
import messages from 'containers/Group/messages';

export function GroupHome(props) {
  return (
    <React.Fragment>
      {
        props.group && (
          <Typography variant='h4' align='center' color='primary'>
            Welcome to the <strong>{props.group.name}</strong>!
          </Typography>
        )
      }
    </React.Fragment>
  );
}

GroupHome.propTypes = {
};

export default compose(
  memo,
)(GroupHome);
