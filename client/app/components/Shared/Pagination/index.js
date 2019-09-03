import React from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';

import { TablePagination, Box } from '@material-ui/core';

const styles = theme => ({
  paginationContainer: {
    '& .MuiToolbar-gutters': {
      paddingLeft: 0,
      paddingRight: 0,
    },
    '& .MuiTablePagination-actions': {
      marginLeft: 0,
    },
    '& .MuiTablePagination-selectRoot': {
      marginLeft: 0,
      marginRight: 8,
    },
    '& .MuiIconButton-root': {
      padding: 6,
    },
  },
});

export function Pagination(props) {
  const { classes, ...rest } = props;

  return (
    <div className={classes.paginationContainer}>
      <TablePagination
        component='div'
        page={props.page}
        rowsPerPageOptions={props.rowsPerPageOptions || [5, 10, 25]}
        rowsPerPage={props.rowsPerPage || 0}
        count={props.count || 0}
        onChangePage={props.onChangePage}
        onChangeRowsPerPage={props.onChangeRowsPerPage}
        backIconButtonProps={{
          'aria-label': 'Previous Page',
        }}
        nextIconButtonProps={{
          'aria-label': 'Next Page',
        }}
      />
    </div>
  );
}

Pagination.propTypes = {
  classes: PropTypes.object,
  page: PropTypes.number,
  rowsPerPageOptions: PropTypes.array,
  rowsPerPage: PropTypes.number,
  count: PropTypes.number,
  onChangePage: PropTypes.func,
  onChangeRowsPerPage: PropTypes.func,
};

export default compose(
  withStyles(styles)
)(Pagination);
