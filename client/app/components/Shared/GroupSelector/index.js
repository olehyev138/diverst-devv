/**
 *
 * GroupSelector
 *
 */

import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';

import {
  getGroupsBegin, groupListUnmount
} from 'containers/Group/actions';

import { compose } from 'redux';
import { connect } from 'react-redux';

import DiverstSelect from '../DiverstSelect';
import { createStructuredSelector } from 'reselect';
import { selectPaginatedSelectGroups, selectGroupIsLoading, selectGroupTotal } from 'containers/Group/selectors';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Group/reducer';
import { useInjectSaga } from 'utils/injectSaga';
import saga from 'containers/Group/saga';
import { Grid, Button } from '@material-ui/core';
import DiverstPagination from 'components/Shared/DiverstPagination';
import DiverstDialog from 'components/Shared/DiverstDialog';
import GroupSelectorItem from 'components/Shared/GroupSelector/item';
import GroupListSelector from 'components/Shared/GroupSelector/dialog';

const GroupSelector = (props) => {
  const { handleChange, values, groupField, setFieldValue, groups, label, queryScopes, ...rest } = props;
  useInjectReducer({ key: 'groups', reducer });
  useInjectSaga({ key: 'groups', saga });
  const [dialogSearch, setDialogSearch] = useState(false);

  const { getGroupsBegin, groupListUnmount, ...selectProps } = rest;

  const [addGroup, removeGroup, onChange] = (() => {
    if (selectProps.isMulti)
      return [
        // MULTI ADD GROUP
        (group) => {
          const index = values[groupField].indexOf(x => x.value === group.value);
          if (index === -1)
            setFieldValue(groupField, [...(values[groupField]), group]);
        },
        // MULTI REMOVE GROUP
        group => setFieldValue(groupField, values[groupField].filter(x => x.value !== group.value)),
        // MULTI ON CHANGE
        value => setFieldValue(groupField, value || [])
      ];
    return [
      // SINGLE ADD GROUP
      group => setFieldValue(groupField, group),
      // SINGLE REMOVE GROUP
      group => values[groupField].value === group.value ? setFieldValue(groupField, '') : null,
      // SINGLE ON CHANGE
      value => setFieldValue(groupField, value || '')
    ];
  })();

  const groupSelectAction = (searchKey = '') => props.inputCallback(props, searchKey);

  useEffect(() => {
    groupSelectAction();

    return () => groupListUnmount();
  }, []);

  return (
    <Grid container>
      <Grid item xs={12}>
        <DiverstSelect
          name={groupField}
          id={groupField}
          margin='normal'
          label={label}
          fullWidth
          options={groups}
          value={values[groupField]}
          onChange={onChange}
          onInputChange={groupSelectAction}
          hideHelperText
          {...selectProps}
        />
      </Grid>
      <Grid item xs={12}>
        <Button
          onClick={() => setDialogSearch(true)}
        >
          Open
        </Button>
      </Grid>
      <DiverstDialog
        open={dialogSearch}
        title='THIS IS A GENERIC TITLE'
        handleNo={() => setDialogSearch(false)}
        content={(
          <GroupListSelector {...props} />
        )}
      />
    </Grid>

  );
};

GroupSelector.propTypes = {
  groupField: PropTypes.string.isRequired,
  label: PropTypes.node.isRequired,
  handleChange: PropTypes.func.isRequired,
  setFieldValue: PropTypes.func.isRequired,
  values: PropTypes.object.isRequired,
  queryScopes: PropTypes.arrayOf(PropTypes.string),
  isLoading: PropTypes.bool,

  getGroupsBegin: PropTypes.func.isRequired,
  groupListUnmount: PropTypes.func.isRequired,
  groups: PropTypes.array,

  inputCallback: PropTypes.func,
};

GroupSelector.defaultProps = {
  inputCallback: (props, searchKey = '', params = {}) => {
    props.getGroupsBegin({
      count: 10, page: 0, order: 'asc',
      search: searchKey,
      query_scopes: props.queryScopes || [],
      ...params,
    });
  },
};

const mapStateToProps = createStructuredSelector({
  groups: selectPaginatedSelectGroups(),
  groupTotal: selectGroupTotal(),
  isLoading: selectGroupIsLoading(),
});

const mapDispatchToProps = {
  getGroupsBegin,
  groupListUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(GroupSelector);
