import React from 'react';
import { compose } from 'redux';
import { withStyles, withTheme } from '@material-ui/core/styles';
import PropTypes from 'prop-types';
import Select from 'react-select';

import { FormControl, FormHelperText, FormLabel } from '@material-ui/core';

const styles = theme => ({
  formControl: {
    minWidth: 150,
  },
  select: {
    width: '100%',
    paddingTop: 8,
  },
  formLabel: {
    fontSize: '0.9rem',
  },
});

export function DiverstLike(props) {
  return (
    <React.Fragment>

    </React.Fragment>
  );
}

DiverstLike.propTypes = {
  newsFeedLinkId: PropTypes.number,
  likeAction: PropTypes.func.isRequired,
  unlike: PropTypes.func.isRequired,
};

export default compose(
  withTheme,
  withStyles(styles),
)(DiverstLike);
