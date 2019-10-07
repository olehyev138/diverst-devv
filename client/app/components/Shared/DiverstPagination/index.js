import React, { memo, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';

import { TablePagination } from '@material-ui/core';

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
    '& .MuiTablePagination-root': {
      color: theme.palette.text.secondary,
    },
  },
});

export function DiverstPagination(props) {
  const { classes, ...rest } = props;

  const [page, setPage] = useState(props.page || 0);
  const [rowsPerPage, setRowsPerPage] = useState(props.rowsPerPage || 10);

  const handleChangePage = (event, newPage) => {
    setPage(newPage);
    props.handlePagination({ count: rowsPerPage, page: newPage });
  };

  const handleChangeRowsPerPage = (event) => {
    setRowsPerPage(+event.target.value);
    props.handlePagination({ count: +event.target.value, page });
  };

  if (props.isLoading === true)
    return undefined;

  return (
    <div className={classes.paginationContainer}>
      <TablePagination
        component='div'
        page={page}
        rowsPerPageOptions={props.rowsPerPageOptions || [5, 10, 25]}
        rowsPerPage={rowsPerPage || 0}
        count={props.count || 0}
        onChangePage={props.onChangePage || handleChangePage}
        onChangeRowsPerPage={props.onChangeRowsPerPage || handleChangeRowsPerPage}
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

DiverstPagination.propTypes = {
  classes: PropTypes.object,
  handlePagination: PropTypes.func.isRequired,
  count: PropTypes.number,
  page: PropTypes.number,
  rowsPerPageOptions: PropTypes.array,
  rowsPerPage: PropTypes.number,
  onChangePage: PropTypes.func,
  onChangeRowsPerPage: PropTypes.func,
  isLoading: PropTypes.bool,
};

export default compose(
  withStyles(styles),
  memo,
)(DiverstPagination);
