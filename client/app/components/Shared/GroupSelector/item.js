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
import {
  Box,
  Card,
  CardActionArea,
  CardContent,
  Collapse,
  Divider,
  Grid,
  Hidden,
  Link,
  Typography
} from '@material-ui/core';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';
import DiverstImg from 'components/Shared/DiverstImg';
import JoinedGroupIcon from '@material-ui/icons/CheckCircle';
import RemoveIcon from '@material-ui/icons/Remove';
import AddIcon from '@material-ui/icons/Add';
import { withStyles } from '@material-ui/core/styles';

const styles = theme => ({
  errorButton: {
    color: theme.palette.error.main,
  },
  groupCard: {
    width: '100%',
    borderLeftWidth: 2,
    borderLeftStyle: 'solid',
    borderLeftColor: theme.palette.primary.main,
    borderTopLeftRadius: 4,
    borderBottomLeftRadius: 4,
  },
  groupCardContent: {
    paddingTop: 20,
    paddingBottom: 20,
  },
  groupCardTitle: {
    verticalAlign: 'middle',
  },
  groupCardIcon: {
    verticalAlign: 'middle',
    marginRight: 6,
  },
  groupCardDescription: {
    paddingTop: 8,
  },
  groupCardLink: {
    textDecoration: 'none !important',
  },
  childGroupCard: {
    marginLeft: 24,
    borderLeftWidth: 2,
    borderLeftStyle: 'solid',
    borderLeftColor: theme.palette.secondary.main,
    borderTopLeftRadius: 4,
    borderBottomLeftRadius: 4,
  },
  expandActionAreaContainer: {
    borderLeftWidth: 1,
    borderLeftStyle: 'solid',
    borderLeftColor: theme.custom.colors.lightGrey,
  },
  expandActionArea: {
    padding: '4px 12px',
    height: '100%',
  },
  expandIcon: {
    fontSize: 34,
  },
});

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
      <Divider />
      <Grid container>
        <Grid item xs>
          <CardContent className={classes.groupCardContent}>
            <Grid container spacing={2} alignItems='center'>
              <React.Fragment>
                <Hidden xsDown>
                  <Grid item xs='auto'>
                    <DiverstImg
                      data={group.logo_data}
                      maxWidth='50px'
                      maxHeight='50px'
                      minWidth='50px'
                      minHeight='50px'
                    />
                  </Grid>
                </Hidden>
              </React.Fragment>
              <Grid item xs>
                <Typography variant='h5' component='h2' display='inline' className={classes.groupCardTitle}>
                  {group.label}
                </Typography>
              </Grid>
            </Grid>
          </CardContent>
        </Grid>
        {group.children && group.children.length > 0 && (
          <Grid item className={classes.expandActionAreaContainer}>
            <CardActionArea
              className={classes.expandActionArea}
              onClick={() => {
                setExpandedGroups({
                  ...expandedGroups,
                  [group.value]: !expandedGroups[group.value]
                });
              }}
            >
              {expandedGroups[group.value] ? (
                <RemoveIcon color='primary' className={classes.expandIcon} />
              ) : (
                <AddIcon color='primary' className={classes.expandIcon} />
              )}
            </CardActionArea>
          </Grid>
        )}
      </Grid>
      <Divider />
      <Collapse in={expandedGroups[`${group.value}`]}>
        <Box mt={1} />
        <Grid container spacing={2} justify='flex-end'>
          {group.children && group.children.map((childGroup, i) => (
            <GroupSelectorItem {...props} group={childGroup} />
          ))}
        </Grid>
      </Collapse>
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
  withStyles(styles),
)(GroupSelectorItem);
