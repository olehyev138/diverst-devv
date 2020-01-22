/**
 *
 * Downloads List Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import withStyles from '@material-ui/core/styles/withStyles';

import {
  Box, Paper, Card, CardContent, Grid, Link, Typography, Button, CardActionArea
} from '@material-ui/core';

import AddIcon from '@material-ui/icons/Add';

import messages from 'containers/User/messages';

import DiverstPagination from 'components/Shared/DiverstPagination';
import DiverstLoader from 'components/Shared/DiverstLoader';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';

const styles = theme => ({
});

export function DownloadsList(props, context) {
  const { classes } = props;

  return (
    <React.Fragment>
    </React.Fragment>
  );
}

DownloadsList.propTypes = {
  classes: PropTypes.object,
  downloads: PropTypes.array,
  downloadsTotal: PropTypes.number,
  isLoading: PropTypes.bool,
  handlePagination: PropTypes.func,
  links: PropTypes.object,
};

export default compose(
  withStyles(styles),
  memo,
)(DownloadsList);
