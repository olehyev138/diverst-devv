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
  Typography,
  ButtonBase
} from '@material-ui/core';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';
import DiverstImg from 'components/Shared/DiverstImg';
import JoinedGroupIcon from '@material-ui/icons/CheckCircle';
import RemoveIcon from '@material-ui/icons/Remove';
import AddIcon from '@material-ui/icons/Add';
import CheckBoxOutlineBlankRoundedIcon from '@material-ui/icons/CheckBoxOutlineBlankRounded';
import CheckBoxRoundedIcon from '@material-ui/icons/CheckBoxRounded';
import { withStyles } from '@material-ui/core/styles';
import useClickPreventionOnDoubleClick from 'utils/customHooks/doubleClickHelper';

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
    paddingTop: 10,
    paddingBottom: 10,
    width: '100%',
  },
  groupCardTitle: {
    verticalAlign: 'middle',
    width: '100%'
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
  buttonBase: {
    width: '100%',
  },
  cardContentSelected: {
    paddingTop: 10,
    paddingBottom: 10,
    width: '100%',
    borderLeftStyle: 'solid',
    borderLeftColor: theme.palette.primary.main,
  },
  cardContentNotSelected: {
    paddingTop: 10,
    paddingBottom: 10,
    width: '100%',
    borderLeftStyle: 'solid',
    borderLeftColor: theme.palette.secondary.main,
  }
});

const GroupSelectorItem = (props) => {
  const { group, classes, ...rest } = props;
  const { getGroupsBegin, groupListUnmount, groupSelectAction, setExpandedGroups, expandedGroups } = rest;

  const [handleClick, handleDoubleClick] = useClickPreventionOnDoubleClick(
    () => {
      if (props.isSelected(props.group))
        props.removeGroup(props.group);
      else
        props.addGroup(props.group);
    },
    () => {
      if (props.isSelected(props.group))
        props.removeGroup(...[props.group, ...props.group.children]);
      else
        props.addGroup(...[props.group, ...props.group.children]);
    },
  );

  const imageDimensions = props.large ? '80px' : '30px';

  return (
    <React.Fragment>
      <Divider />
      <Grid container>
        <Grid item xs>
          <ButtonBase
            onClick={handleClick}
            onDoubleClick={handleDoubleClick}
            className={classes.buttonBase}
          >
            <CardContent className={props.isSelected(props.group) ? classes.cardContentSelected : classes.cardContentNotSelected}>
              <Grid container spacing={2} alignItems='center' alignContent='flex-start'>
                <Hidden xsDown>
                  <Grid item xs='auto'>
                    <DiverstImg
                      data={group.logo_data}
                      maxWidth={imageDimensions}
                      maxHeight={imageDimensions}
                      minWidth={imageDimensions}
                      minHeight={imageDimensions}
                    />
                  </Grid>
                </Hidden>
                {!props.large && (
                  <Grid item xs='auto'>
                    {props.isSelected(props.group) ? <CheckBoxRoundedIcon /> : <CheckBoxOutlineBlankRoundedIcon />}
                  </Grid>
                )}
                <Grid item xs>
                  <Typography variant='h5' component='h2' className={classes.groupCardTitle}>
                    {group.label || group.name}
                  </Typography>
                </Grid>
              </Grid>
            </CardContent>
          </ButtonBase>
        </Grid>
        {!props.dialogNoChildren && group.children && group.children.length > 0 && (
          <Grid item className={classes.expandActionAreaContainer}>
            <CardActionArea
              className={classes.expandActionArea}
              onClick={() => {
                setExpandedGroups({
                  ...expandedGroups,
                  [group.value || group.id]: !expandedGroups[group.value || group.id]
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
      <Collapse in={expandedGroups[`${group.value || group.id}`]}>
        {group.children && group.children.map((childGroup, i) => (
          <React.Fragment key={childGroup.value || childGroup.id}>
            <GroupSelectorItem {...props} group={childGroup} child />
          </React.Fragment>
        ))}
      </Collapse>
      {props.large && !props.child ? <Box mb={1} /> : <React.Fragment />}
    </React.Fragment>
  );
};

GroupSelectorItem.propTypes = {
  classes: PropTypes.object,
  group: PropTypes.shape({
    value: PropTypes.number,
    label: PropTypes.string,
    children: PropTypes.arrayOf(PropTypes.object)
  }).isRequired,

  dialogNoChildren: PropTypes.bool,
  inputCallback: PropTypes.func,
  addGroup: PropTypes.func,
  removeGroup: PropTypes.func,
  isSelected: PropTypes.func,
  large: PropTypes.bool,
  child: PropTypes.bool,
  selected: PropTypes.oneOfType([
    PropTypes.arrayOf(PropTypes.object),
    PropTypes.object
  ]),
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
