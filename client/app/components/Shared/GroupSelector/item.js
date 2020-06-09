import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';

import {
  getGroupsBegin, groupListUnmount
} from 'containers/Group/actions';

import { compose } from 'redux';
import { connect } from 'react-redux';

import DiverstSelect from '../DiverstSelect';
import { createStructuredSelector } from 'reselect';
import { selectPaginatedSelectGroups, selectGroupIsLoading } from 'containers/Group/selectors';
import DiverstPagination from 'components/Shared/DiverstPagination';
import { Box, Card, CardActionArea, CardContent, Collapse, Grid, Hidden, Link, Typography } from '@material-ui/core';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';
import DiverstImg from 'components/Shared/DiverstImg';
import JoinedGroupIcon from '@material-ui/icons/CheckCircle';
import RemoveIcon from '@material-ui/icons/Remove';
import AddIcon from '@material-ui/icons/Add';

const GroupSelectorItem = (props) => {
  const { handleChange, values, groupField, setFieldValue, label, queryScopes, group, classes, ...rest } = props;
  const { getGroupsBegin, groupListUnmount, groupSelectAction, setExpandedGroups, expandedGroups, ...selectProps } = rest;

  /*
      <DiverstSelect
        label={groupField}
        value={groupField}
        margin='normal'
        label={label}
        fullWidth
        options={rest.groups}
        value={values[groupField]}
        onChange={value => setFieldValue(groupField, value || (selectProps.isMulti ? [] : ''))}
        onInputChange={groupSelectAction}
        hideHelperText
        {...selectProps}
      />
   */

  return (
    <React.Fragment>
      <Grid item xs={12} key={group.value}>
        <Grid container>
          <Grid item xs>
            <CardContent>
              <Grid container spacing={2} alignItems='center'>
                {group.logo_data && (
                  <React.Fragment>
                    <Hidden xsDown>
                      <Grid item xs='auto'>
                        <DiverstImg
                          data={group.logo_data}
                          maxWidth='70px'
                          maxHeight='70px'
                          minWidth='70px'
                          minHeight='70px'
                        />
                      </Grid>
                    </Hidden>
                  </React.Fragment>
                )}
                <Grid item xs>
                  <Typography variant='h5' component='h2' display='inline'>
                    {group.label}
                  </Typography>
                </Grid>
              </Grid>
            </CardContent>
          </Grid>
          {group.children && group.children.length > 0 && (
            <Grid item>
              <CardActionArea
                onClick={() => {
                  setExpandedGroups({
                    ...expandedGroups,
                    [group.value]: !expandedGroups[group.value]
                  });
                }}
              >
                {expandedGroups[group.value] ? (
                  <RemoveIcon color='primary' />
                ) : (
                  <AddIcon color='primary' />
                )}
              </CardActionArea>
            </Grid>
          )}
        </Grid>
        <Collapse in={expandedGroups[`${group.value}`]}>
          <Box mt={1} />
          <Grid container spacing={2} justify='flex-end'>
            {group.children && group.children.map((childGroup, i) => (
              <GroupSelectorItem {...props} group={childGroup} />
            ))}
          </Grid>
        </Collapse>
      </Grid>
    </React.Fragment>
  );
};

GroupSelectorItem.propTypes = {
  classes: PropTypes.object,
  groupField: PropTypes.string.isRequired,
  label: PropTypes.node.isRequired,
  handleChange: PropTypes.func.isRequired,
  setFieldValue: PropTypes.func.isRequired,
  values: PropTypes.object.isRequired,
  queryScopes: PropTypes.arrayOf(PropTypes.string),
  isLoading: PropTypes.bool,

  expandedGroups: PropTypes.object,
  setExpandedGroups: PropTypes.func,

  getGroupsBegin: PropTypes.func.isRequired,
  groupListUnmount: PropTypes.func.isRequired,
  group: PropTypes.shape({
    value: PropTypes.number,
    label: PropTypes.string,
    children: PropTypes.arrayOf(PropTypes.object)
  }).isRequired,

  inputCallback: PropTypes.func,
};

const mapStateToProps = createStructuredSelector({
  groups: selectPaginatedSelectGroups(),
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
)(GroupSelectorItem);
