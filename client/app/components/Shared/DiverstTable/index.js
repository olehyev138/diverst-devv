import React, { memo, useEffect, useRef, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';

import MaterialTable, { MTableHeader } from 'material-table';
import tableIcons from 'utils/tableIcons';

import buildDataFunction from 'utils/dataTableHelper';

const styles = theme => ({
  materialTableContainer: {
    '& .MuiButtonBase-root.Mui-disabled': {
      wordBreak: 'keep-all',
      '& > svg': {
        display: 'none',
      },
    },
  },
});

export function DiverstTable(props) {
  const { classes, params, ...rest } = props;

  const [pageState, setPage] = useState(props.page || 0);
  const [rowsPerPageState, setRowsPerPage] = useState(props.rowsPerPage || 10);

  const page = () => params ? params.page : pageState;
  const rowsPerPage = () => params ? params.count : rowsPerPageState;

  const handleChangePage = (newPage) => {
    setPage(newPage);
    props.handlePagination({ count: rowsPerPage(), page: newPage });
  };

  const handleChangeRowsPerPage = (pageSize) => {
    setRowsPerPage(+pageSize);
    props.handlePagination({ count: +pageSize, page: page() });
  };

  const handleOrderChange = (columnId, orderDir) => {
    props.handleOrdering({
      orderBy: (columnId === -1) ? 'id' : props.columns[columnId].field,
      orderDir: (columnId === -1) ? 'asc' : orderDir
    });
  };

  /* Store reference to table & use to refresh table when data changes */
  const ref = useRef();
  useEffect(() => {
    if (ref.current)
      ref.current.onQueryChange({ page: page(), pageSize: rowsPerPage() });
  }, [props.dataArray]);

  return (
    <div className={classes.materialTableContainer}>
      <MaterialTable
        tableRef={ref}
        page={page()}
        icons={tableIcons}
        title={props.title}
        onChangePage={handleChangePage}
        onChangeRowsPerPage={handleChangeRowsPerPage}
        onOrderChange={handleOrderChange}
        onRowClick={props.handleRowClick}
        data={buildDataFunction(props.dataArray, page() || 0, props.dataTotal || 0)}
        columns={props.columns}
        actions={props.actions}
        options={{
          ...props.my_options,
          actionsColumnIndex: -1,
          pageSize: rowsPerPage(),
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
  handleRowClick: PropTypes.func,
  title: PropTypes.string,
  page: PropTypes.number,
  rowsPerPage: PropTypes.number,
  params: PropTypes.object,
  my_options: PropTypes.object,
};

export default compose(
  withStyles(styles),
  memo,
)(DiverstTable);
