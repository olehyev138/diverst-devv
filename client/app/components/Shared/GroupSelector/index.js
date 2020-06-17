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
import { union, difference, intersection } from 'utils/arrayHelpers';
import reducer from 'containers/Group/reducer';
import { useInjectSaga } from 'utils/injectSaga';
import saga from 'containers/Group/saga';
import { Grid, Button } from '@material-ui/core';
import DiverstPagination from 'components/Shared/DiverstPagination';
import DiverstDialog from 'components/Shared/DiverstDialog';
import GroupSelectorItem from 'components/Shared/GroupSelector/item';
import GroupListSelector from 'components/Shared/GroupSelector/dialog';
import messages from 'containers/Group/messages';
import { DiverstFormattedMessage } from 'components/Shared/DiverstFormattedMessage';

const GroupSelector = (props) => {
  const { handleChange, values, groupField, setFieldValue, groups, label, queryScopes, ...rest } = props;
  useInjectReducer({ key: 'groups', reducer });
  useInjectSaga({ key: 'groups', saga });
  const [dialogSearch, setDialogSearch] = useState(false);

  const { getGroupsBegin, groupListUnmount, ...selectProps } = rest;

  function groupCompare(g1, g2) {
    return g1.value === g2.value;
  }

  const [addGroup, removeGroup, onChange, isSelected] = (() => {
    if (selectProps.isMulti)
      return [
        // MULTI ADD GROUP
        (...groups) => setFieldValue(groupField, union(values[groupField], groups, groupCompare)),
        // MULTI REMOVE GROUP
        (...groups) => setFieldValue(groupField, difference(values[groupField], groups, groupCompare)),
        // MULTI ON CHANGE
        value => setFieldValue(groupField, value || []),
        // MULTI IS SELECTED
        group => !!(values[groupField].find(x => x.value === group.value))
      ];
    return [
      // SINGLE ADD GROUP
      group => setFieldValue(groupField, group),
      // SINGLE REMOVE GROUP
      group => values[groupField].value === group.value ? setFieldValue(groupField, '') : null,
      // SINGLE ON CHANGE
      value => setFieldValue(groupField, value || ''),
      // SINGLE IS SELECTED
      group => values[groupField].value === group.value
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
        title={<DiverstFormattedMessage {...messages.selectorDialog.title} />}
        subTitle={<DiverstFormattedMessage {...messages.selectorDialog.subTitle} />}
        handleNo={() => setDialogSearch(false)}
        textNo={<DiverstFormattedMessage {...messages.selectorDialog.close} />}
        paperProps={{
          style: {
            maxHeight: '90%',
            minHeight: '90%',
            minWidth: '40%',
          }
        }}
        content={(
          <GroupListSelector
            groups={groups}
            groupTotal={rest.groupTotal}
            isLoading={rest.isLoading}
            inputCallback={props.inputCallback}
            getGroupsBegin={props.getGroupsBegin}
            open={dialogSearch}
            addGroup={addGroup}
            removeGroup={removeGroup}
            isSelected={isSelected}
            selected={values[groupField]}
          />
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
