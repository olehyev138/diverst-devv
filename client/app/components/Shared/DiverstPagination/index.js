import React, { memo, useState, useEffect } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';

import { TablePagination } from '@material-ui/core';

import animateScrollTo from 'animated-scroll-to';

import { CONTENT_SCROLL_CLASS_NAME } from 'components/Shared/Scrollbar';

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

  const [paginationKey] = useState(Math.random().toString(36).substring(10));
  const [page, setPage] = useState(props.page || 0);
  const [rowsPerPage, setRowsPerPage] = useState(props.rowsPerPage || 10);
  const [doScrollToBottom, setDoScrollToBottom] = useState(false);

  const paginationClassName = `pagination-${paginationKey}`;

  const handleChangePage = (event, newPage) => {
    let scroll = true;
    if (newPage < page) {
      setDoScrollToBottom(true);
      scroll = false;
    }

    setPage(newPage);
    props.handlePagination({ count: rowsPerPage, page: newPage });

    if (scroll)
      animateScrollTo(0, {
        elementToScroll: document.querySelector(`.${CONTENT_SCROLL_CLASS_NAME}`)
      });
  };

  const handleChangeRowsPerPage = (event) => {
    setRowsPerPage(+event.target.value);
    props.handlePagination({ count: +event.target.value, page });
  };

  useEffect(() => {
    if (props.isLoading === false && doScrollToBottom === true) {
      setDoScrollToBottom(false);
      animateScrollTo(document.querySelector(`.${paginationClassName}`), {
        elementToScroll: document.querySelector(`.${CONTENT_SCROLL_CLASS_NAME}`)
      });
    }
  }, [props.isLoading]);

  if (props.isLoading === true)
    return undefined;

  return (
    <div className={classes.paginationContainer}>
      <TablePagination
        className={paginationClassName}
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
