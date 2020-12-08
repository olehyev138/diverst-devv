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
import { withStyles, lighten } from '@material-ui/core/styles';
import useClickPreventionOnDoubleClick from 'utils/customHooks/doubleClickHelper';
import classNames from 'classnames';

const styles = theme => ({
  itemContainer: {
    display: 'flex',
    flexDirection: 'column',
    flex: 1,
    maxHeight: 140,
  },
  itemGridContainer: {
    flex: 1,
  },
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
  groupCardTitleNoChildren: {
    paddingRight: 58, // Compensate for children expand button & icon
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
    borderRightWidth: 1,
    borderRightStyle: 'solid',
    borderRightColor: theme.palette.secondary.main,
    borderTopLeftRadius: 4,
    borderBottomLeftRadius: 4,
  },
  expandActionAreaContainer: {
    borderRightWidth: 1,
    borderRightStyle: 'solid',
    borderRightColor: theme.custom.colors.lightGrey,
  },
  expandActionAreaContainerSelected: {
    borderRightWidth: 1,
    borderRightStyle: 'solid',
    borderRightColor: theme.custom.colors.lightGrey,
    background: lighten(theme.palette.primary.main, 0.85),
  },
  expandActionArea: {
    padding: '4px 12px',
    height: '100%',
  },
  expandIcon: {
    fontSize: 34,
  },
  buttonBase: {
    height: '100%',
    width: '100%',
    textAlign: 'justify',
  },
  cardContentSelected: {
    display: 'flex',
    paddingTop: 10,
    paddingBottom: 10,
    height: '100%',
    width: '100%',
    borderLeftStyle: 'solid',
    borderLeftColor: theme.palette.primary.main,
    background: lighten(theme.palette.primary.main, 0.85),
    borderRightWidth: 1,
    borderRightStyle: 'solid',
    borderRightColor: theme.custom.colors.lightGrey,
  },
  cardContentNotSelected: {
    display: 'flex',
    paddingTop: 10,
    paddingBottom: 10,
    height: '100%',
    width: '100%',
    borderLeftStyle: 'solid',
    borderLeftColor: theme.palette.secondary.main,
    borderRightWidth: 1,
    borderRightStyle: 'solid',
    borderRightColor: theme.custom.colors.lightGrey,
  },
});

const GroupSelectorItem = (props) => {
  const { group, classes, doubleClickWait, ...rest } = props;
  const { getGroupsBegin, groupListUnmount, groupSelectAction } = rest;

  const [handleClick, handleDoubleClick] = useClickPreventionOnDoubleClick(
    () => {
      if (props.isSelected(props.group))
        props.removeGroup(props.group);
      else
        props.addGroup(props.group);
    },
    () => {
      if (props.isSelected(props.group))
        props.removeGroup(...[props.group]);
      else
        props.addGroup(...[props.group]);
    },
    doubleClickWait,
  );

  const imageDimensions = props.large ? '80px' : '30px';

  const groupCardClasses = props.isSelected(group) ? classes.cardContentSelected : classes.cardContentNotSelected;
  let groupCardTitleClasses = classes.groupCardTitle;
  let groupCardShortDescriptionClasses = classes.groupCardTitle;

  if (group.is_parent_group !== true)
    if (props.large) groupCardShortDescriptionClasses = classNames(groupCardShortDescriptionClasses, classes.groupCardTitleNoChildren);
    else groupCardTitleClasses = classNames(groupCardTitleClasses, classes.groupCardTitleNoChildren);

  return (
    <Box className={classes.itemContainer}>
      <Divider />
      <Grid container alignItems='stretch' className={classes.itemGridContainer}>
        <Grid item xs>
          <ButtonBase
            onClick={handleClick}
            onDoubleClick={handleDoubleClick}
            className={classes.buttonBase}
          >
            <CardContent className={groupCardClasses}>
              <Grid container spacing={2} alignItems='center' alignContent='center'>
                <Hidden xsDown>
                  <Grid item xs='auto'>
                    <DiverstImg
                      data={group.logo_data}
                      contentType={group.logo_content_type}
                      maxWidth={imageDimensions}
                      maxHeight={imageDimensions}
                      minWidth={imageDimensions}
                      minHeight={imageDimensions}
                      emptyVariant='placeholder'
                    />
                  </Grid>
                </Hidden>
                {!props.large && (
                  <Grid item xs='auto'>
                    {props.isSelected(props.group) ? <CheckBoxRoundedIcon /> : <CheckBoxOutlineBlankRoundedIcon />}
                  </Grid>
                )}
                <Grid item xs>
                  <Typography variant='h5' component='h2' className={groupCardTitleClasses}>
                    {group.label || group.name}
                  </Typography>
                  {props.large && (
                    <Typography variant='body1' component='h3' className={groupCardShortDescriptionClasses} color='secondary'>
                      {group.short_description}
                    </Typography>
                  )}
                </Grid>
              </Grid>

            </CardContent>
          </ButtonBase>
        </Grid>
        {(!props.dialogNoChildren && group.is_parent_group === true) && (
          <Grid item className={props.isSelected(props.group) ? classes.expandActionAreaContainerSelected : classes.expandActionAreaContainer}>
            <CardActionArea
              className={classes.expandActionArea}
              onClick={() => props.handleParentExpand(group.value || group.id, group.label || group.name)}
            >
              <AddIcon color='primary' className={classes.expandIcon} />
            </CardActionArea>
          </Grid>
        )}
      </Grid>
      {props.isLastGroup === true && (
        <Divider />
      )}
      {props.large && !props.child ? <Box mb={1} /> : <React.Fragment />}
    </Box>
  );
};

GroupSelectorItem.propTypes = {
  classes: PropTypes.object,
  group: PropTypes.shape({
    value: PropTypes.number,
    label: PropTypes.string,
    is_parent_group: PropTypes.bool,
  }).isRequired,

  parentData: PropTypes.object,
  displayParentUI: PropTypes.bool,
  handleParentExpand: PropTypes.func,

  isLastGroup: PropTypes.bool,

  dialogNoChildren: PropTypes.bool,
  inputCallback: PropTypes.func,
  addGroup: PropTypes.func,
  removeGroup: PropTypes.func,
  isSelected: PropTypes.func,
  large: PropTypes.bool,
  child: PropTypes.bool,
  doubleClickWait: PropTypes.number,
  selected: PropTypes.oneOfType([
    PropTypes.arrayOf(PropTypes.object),
    PropTypes.object
  ]),
};

GroupSelectorItem.defaultProps = {
  doubleClickWait: 200,
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
