import React, { memo, useState, useEffect } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles, useTheme } from '@material-ui/core/styles';
import { TablePagination, IconButton } from '@material-ui/core';
import FirstPageIcon from '@material-ui/icons/FirstPage';
import KeyboardArrowLeft from '@material-ui/icons/KeyboardArrowLeft';
import KeyboardArrowRight from '@material-ui/icons/KeyboardArrowRight';
import LastPageIcon from '@material-ui/icons/LastPage';

import animateScrollTo from 'animated-scroll-to';

import { CONTENT_SCROLL_CLASS_NAME } from 'components/Shared/Scrollbar';

const paginationActionsStyles = theme => ({
  root: {
    flexShrink: 0,
    marginLeft: theme.spacing(2.5),
  },
});

function PaginationActions(props) {
  const theme = useTheme();
  const { classes, count, page, rowsPerPage, onChangePage } = props;

  const handleFirstPageButtonClick = event => onChangePage(event, 0);

  const handleBackButtonClick = event => onChangePage(event, page - 1);

  const handleNextButtonClick = event => onChangePage(event, page + 1);

  const handleLastPageButtonClick = event => onChangePage(event, Math.max(0, Math.ceil(count / rowsPerPage) - 1));

  return (
    <div className={classes.root}>
      <IconButton
        onClick={handleFirstPageButtonClick}
        disabled={page === 0}
        aria-label='first page'
      >
        {theme.direction === 'rtl' ? <LastPageIcon /> : <FirstPageIcon />}
      </IconButton>
      <IconButton
        onClick={handleBackButtonClick}
        disabled={page === 0}
        aria-label='previous page'
      >
        {theme.direction === 'rtl' ? <KeyboardArrowRight /> : <KeyboardArrowLeft />}
      </IconButton>
      <IconButton
        onClick={handleNextButtonClick}
        disabled={page >= Math.ceil(count / rowsPerPage) - 1}
        aria-label='next page'
      >
        {theme.direction === 'rtl' ? <KeyboardArrowLeft /> : <KeyboardArrowRight />}
      </IconButton>
      <IconButton
        onClick={handleLastPageButtonClick}
        disabled={page >= Math.ceil(count / rowsPerPage) - 1}
        aria-label='last page'
      >
        {theme.direction === 'rtl' ? <FirstPageIcon /> : <LastPageIcon />}
      </IconButton>
    </div>
  );
}

PaginationActions.propTypes = {
  classes: PropTypes.object,
  count: PropTypes.number.isRequired,
  onChangePage: PropTypes.func.isRequired,
  page: PropTypes.number.isRequired,
  rowsPerPage: PropTypes.number.isRequired,
};

const PaginationActionsComponent = withStyles(paginationActionsStyles)(PaginationActions);

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
    setPage(0);
    props.handlePagination({ count: +event.target.value, page: 0 });
  };

  useEffect(() => {
    if (props.isLoading === false && doScrollToBottom === true) {
      setDoScrollToBottom(false);
      animateScrollTo(document.querySelector(`.${paginationClassName}`), {
        elementToScroll: document.querySelector(`.${CONTENT_SCROLL_CLASS_NAME}`)
      });
    }
  }, [props.isLoading]);

  if (props.isLoading === true || props.rowsPerPage <= 0 || props.count <= 0)
    return <React.Fragment />;

  // If out of bounds, return to page 0, useful for lists with changing data
  if (page >= Math.ceil(props.count / rowsPerPage) || props.page !== page)
    setPage(0);

  return (
    <div className={classes.paginationContainer}>
      <TablePagination
        className={paginationClassName}
        ActionsComponent={PaginationActionsComponent}
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
