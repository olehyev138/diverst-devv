/**
 *
 * GroupSelector
 *
 */

import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';

import {
  getGroupsBegin, groupListUnmount, getGroupsSuccess
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
import DiverstDialog from 'components/Shared/DiverstDialog';
import GroupListSelector from 'components/Shared/GroupSelector/dialog';
import messages from 'containers/Group/messages';
import { DiverstFormattedMessage } from 'components/Shared/DiverstFormattedMessage';

const GroupSelector = (props) => {
  const { handleChange, values, groupField, setFieldValue, dialogSelector, groups, label, queryScopes, forceReload, dialogNoChildren, ...rest } = props;
  useInjectReducer({ key: 'groups', reducer });
  useInjectSaga({ key: 'groups', saga });
  const [dialogSearch, setDialogSearch] = useState(false);
  const [dialogSelectedGroups, setDialogSelectedGroups] = useState({});

  const { getGroupsBegin, groupListUnmount, ...selectProps } = rest;

  function groupCompare(g1, g2) {
    return g1.value === g2.value;
  }

  const onChange = (() => {
    if (selectProps.isMulti)
      return value => setFieldValue(groupField, value || []);
    return value => setFieldValue(groupField, value || '');
  })();

  const [addGroup, removeGroup, isSelected] = (() => {
    if (selectProps.isMulti)
      return [
        // MULTI ADD GROUP
        (...groups) => setDialogSelectedGroups(union(dialogSelectedGroups, groups, groupCompare)),
        // MULTI REMOVE GROUP
        (...groups) => setDialogSelectedGroups(difference(dialogSelectedGroups, groups, groupCompare)),
        // MULTI IS SELECTED
        group => !!(dialogSelectedGroups.find(x => x.value === group.value))
      ];
    return [
      // SINGLE ADD GROUP
      group => setDialogSelectedGroups(group),
      // SINGLE REMOVE GROUP
      group => dialogSelectedGroups.value === group.value ? setDialogSelectedGroups('') : null,
      // SINGLE IS SELECTED
      group => dialogSelectedGroups.value === group.value
    ];
  })();

  const groupSelectAction = (searchKey = '') => {
    if (props.forceReload)
      props.getGroupsSuccess({ items: [] });
    props.inputCallback(props, searchKey);
  };

  useEffect(() => {
    groupSelectAction();

    return () => groupListUnmount();
  }, []);

  return (
    <Grid container alignContent='center' alignItems='center' spacing={2}>
      <Grid item style={{ flex: 1 }}>
        <DiverstSelect
          name={groupField}
          id={groupField}
          margin='normal'
          label={label}
          fullWidth
          forceReload={forceReload}
          options={groups}
          value={values[groupField]}
          onChange={onChange}
          onInputChange={groupSelectAction}
          onFocus={event => groupSelectAction('')}
          hideHelperText
          {...selectProps}
        />
      </Grid>
      {dialogSelector && (
        <Grid item>
          <Button
            onClick={() => {
              setDialogSelectedGroups(values[groupField]);
              setDialogSearch(true);
            }}
          >
            <DiverstFormattedMessage {...messages.selectorDialog.select} />
          </Button>
        </Grid>
      )}
      <DiverstDialog
        open={dialogSearch}
        title={<DiverstFormattedMessage {...messages.selectorDialog.title} />}
        handleYes={() => {
          onChange(dialogSelectedGroups);
          setDialogSearch(false);
        }}
        textYes={<DiverstFormattedMessage {...messages.selectorDialog.save} />}
        handleNo={() => setDialogSearch(false)}
        textNo={<DiverstFormattedMessage {...messages.selectorDialog.close} />}
        extraActions={[
          {
            key: 'clear groups',
            func: () => setDialogSelectedGroups([]),
            label: <DiverstFormattedMessage {...messages.selectorDialog.clear} />,
            color: 'secondary'
          }
        ]}
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
            dialogNoChildren={props.dialogNoChildren}
            queryScopes={props.queryScopes}
          />
        )}
      />
    </Grid>

  );
};

GroupSelector.propTypes = {
  dialogSelector: PropTypes.bool,
  dialogNoChildren: PropTypes.bool,
  forceReload: PropTypes.bool,

  groupField: PropTypes.string.isRequired,
  label: PropTypes.node.isRequired,
  handleChange: PropTypes.func.isRequired,
  setFieldValue: PropTypes.func.isRequired,
  values: PropTypes.object.isRequired,
  queryScopes: PropTypes.arrayOf(PropTypes.string),
  isLoading: PropTypes.bool,

  getGroupsBegin: PropTypes.func.isRequired,
  groupListUnmount: PropTypes.func.isRequired,
  getGroupsSuccess: PropTypes.func.isRequired,
  groups: PropTypes.array,
  extraParams: PropTypes.object,

  inputCallback: PropTypes.func,
};

GroupSelector.defaultProps = {
  inputCallback: (props, searchKey = '', params = {}) => {
    props.getGroupsBegin({
      count: 10, page: 0, order: 'asc',
      search: searchKey,
      query_scopes: props.queryScopes || [],
      ...props.extraParams,
      ...params,
    });
  },
  extraParams: {},
};

const mapStateToProps = createStructuredSelector({
  groups: selectPaginatedSelectGroups(),
  groupTotal: selectGroupTotal(),
  isLoading: selectGroupIsLoading(),
});

const mapDispatchToProps = {
  getGroupsBegin,
  groupListUnmount,
  getGroupsSuccess
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(GroupSelector);
