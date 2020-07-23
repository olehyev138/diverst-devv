import React, { memo, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';

import MaterialTable from 'material-table';
import tableIcons from 'utils/tableIcons';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'components/Shared/DiverstTable/messages';

const styles = theme => ({
  materialTableContainer: {
    '& .MuiButtonBase-root.Mui-disabled': {
      wordBreak: 'keep-all',
      '& > svg': {
        display: 'none',
      },
    },
    '& .MuiTableCell-head': {
      zIndex: 0,
    },
  },
});

export function DiverstTable(props) {
  const { classes, params, dataArray, dataTotal, page, rowsPerPage, title, columns, actions, isStatic, tableOptions, ...rest } = props;

  const [pageState, setPage] = useState(page || 0);
  const [rowsPerPageState, setRowsPerPage] = useState(rowsPerPage || 10);

  const currentPage = () => params ? params.page : pageState;
  const currentRowsPerPage = () => params ? params.count : rowsPerPageState;

  const handleChangePage = (newPage) => {
    setPage(newPage);
    props.handlePagination({ count: currentRowsPerPage(), page: newPage });
  };

  const handleChangeRowsPerPage = (pageSize) => {
    setRowsPerPage(+pageSize);
    props.handlePagination({ count: +pageSize, page: currentPage() });
  };

  const handleOrderChange = (columnId, orderDir) => {
    props.handleOrdering({
      orderBy: (columnId === -1) ? 'id' : columns[columnId].field,
      orderDir: (columnId === -1) ? 'asc' : orderDir
    });
  };

  const handleSearchChange = searchText => props.handleSearching && props.handleSearching(searchText);

  return (
    <div className={classes.materialTableContainer}>
      <MaterialTable
        data={dataArray || []}
        totalCount={dataTotal || 0}
        page={currentPage()}
        icons={tableIcons}
        title={title || <DiverstFormattedMessage {...messages.title} />}
        onChangePage={handleChangePage}
        onChangeRowsPerPage={handleChangeRowsPerPage}
        onOrderChange={handleOrderChange}
        onSearchChange={handleSearchChange}
        onRowClick={props.handleRowClick}
        columns={columns}
        actions={actions}
        options={{
          search: !!props.handleSearching, // Disable searching when callback isn't passed
          actionsColumnIndex: -1,
          pageSize: currentRowsPerPage(),
          emptyRowsWhenPaging: false,
          debounceInterval: 1000,
          ...tableOptions,
        }}
        {...rest}
      />
    </div>
  );
}

DiverstTable.propTypes = {
  classes: PropTypes.object,
  dataArray: PropTypes.array.isRequired,
  dataTotal: PropTypes.number,
  columns: PropTypes.array.isRequired,
  actions: PropTypes.array,
  handlePagination: PropTypes.func.isRequired,
  handleOrdering: PropTypes.func,
  handleSearching: PropTypes.func,
  handleRowClick: PropTypes.func,
  title: PropTypes.string,
  page: PropTypes.number,
  rowsPerPage: PropTypes.number,
  params: PropTypes.object,
  isStatic: PropTypes.bool,
  tableOptions: PropTypes.object,
};

export default compose(
  withStyles(styles),
  memo,
)(DiverstTable);
