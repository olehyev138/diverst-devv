import React, { memo, useEffect, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import DiverstPagination from 'components/Shared/DiverstPagination';
import GroupSelectorItem from './item';
import { Typography, Fade, Grid, TextField, Box, IconButton, Button, withStyles } from '@material-ui/core';
import DiverstLoader from 'components/Shared/DiverstLoader';
import messages from 'containers/Group/messages';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import ClearIcon from '@material-ui/icons/Clear';
import { union } from 'utils/arrayHelpers';
import useDelayedTextInputCallback from 'utils/customHooks/delayedTextInputCallback';
import { injectIntl, intlShape } from 'react-intl';

const styles = {
  search: {
    marginBottom: 15,
  },
  container: {
    display: 'flex',
    flexDirection: 'column',
    flex: 1,
  },
  list: {
    display: 'flex',
    flexDirection: 'column',
    flex: 1,
    paddingBottom: 1,
  },
  listLoaderWrapper: {
    display: 'flex',
    flexDirection: 'column',
    flex: 1,
  },
  clearSearchTextButton: {
    padding: 0,
  },
};

const GroupListSelector = (props) => {
  const { groups, classes, intl, customTexts, displayParentUI, parentData, setDisplayParentUI, setParentData, ...rest } = props;

  const [params, setParams] = useState({ count: 10, page: 0, query_scopes: union(props.queryScopes, props.dialogQueryScopes) });

  const [searchKey, setSearchKey] = useState('');

  const groupSearchAction = (searchKey = searchKey, params = params, clearParentUI = true) => {
    if (clearParentUI) setDisplayParentUI(false);

    setParams(params);
    props.inputCallback(props, searchKey, params);
  };

  const delayedSearchAction = useDelayedTextInputCallback(groupSearchAction);

  useEffect(() => {
    if (props.open)
      groupSearchAction(searchKey, params, false);
  }, [props.open]);

  useEffect(() => {
    if (parentData === undefined || !parentData?.id) return;

    groupSearchAction('', { ...params, page: 0, query_scopes: union(props.queryScopes, [['children_of', parentData?.id]]) }, false);
  }, [parentData?.id]);

  const header = (
    <Typography color='secondary' variant='body1'>
      <DiverstFormattedMessage {...messages.selectorDialog.subTitle} />
    </Typography>
  );

  const searchBar = (
    <React.Fragment>
      <Fade
        in={!props.isDisplayingChildren}
        appear
        mountOnEnter
        unmountOnExit
        onExited={props.handleFinishExitTransition}
      >
        <Grid container justify='space-between' alignContent='center' alignItems='center'>
          <Grid item style={{ flex: 1 }}>
            <TextField
              placeholder={intl.formatMessage(messages.selectorDialog.searchPlaceholder, customTexts)}
              margin='dense'
              id='search key'
              fullWidth
              type='text'
              onChange={(e) => {
                setSearchKey(e.target.value);
                delayedSearchAction(e.target.value, { ...params, page: 0 });
              }}
              value={searchKey}
              InputProps={{
                endAdornment: searchKey && (
                  <IconButton
                    className={classes.clearSearchTextButton}
                    onClick={() => {
                      setSearchKey('');
                      groupSearchAction('', params);
                    }}
                  >
                    <ClearIcon />
                  </IconButton>
                ),
              }}
            />
          </Grid>
        </Grid>
      </Fade>

      <Fade
        in={displayParentUI}
        appear
        mountOnEnter
        unmountOnExit
        onExited={() => {
          setParentData(null);
          setSearchKey('');
        }}
      >
        <Box pt={1} style={{ overflow: 'hidden' }}>
          <Grid container spacing={1}>
            <Grid item>
              <Button
                size='small'
                color='primary'
                variant='contained'
                onClick={() => {
                  setParentData({ name: parentData?.name });
                  groupSearchAction('', { ...params, page: 0, query_scopes: union(props.queryScopes, props.dialogQueryScopes) });
                }}
              >
                <DiverstFormattedMessage {...messages.back} />
              </Button>
            </Grid>
            <Grid item xs align='center'>
              <Typography component='span' color='primary' variant='h5' className={classes.headerText}>
                {parentData?.name}
              </Typography>
              &nbsp;
              &nbsp;
              <Typography component='span' color='textSecondary' variant='h5' className={classes.headerText}>
                <DiverstFormattedMessage {...messages.childList} />
              </Typography>
            </Grid>
          </Grid>
        </Box>
      </Fade>
    </React.Fragment>
  );

  const list = (
    <DiverstLoader
      isLoading={props.isLoading}
      transition={Fade}
      wrapperProps={{
        className: classes.listLoaderWrapper,
      }}
    >
      {(groups || []).map((group, index) => (
        <GroupSelectorItem
          key={group.value}
          {...rest}
          group={group}
          dialogNoChildren={props.dialogNoChildren}
          isLastGroup={index === groups.length - 1}
        />
      ))}
      {(!groups || groups.length === 0) && (
        <Typography variant='h6' color='secondary' align='center'>
          <DiverstFormattedMessage {...messages.selectorDialog.empty} />
        </Typography>
      )}
    </DiverstLoader>
  );

  const paginator = (
    <DiverstPagination
      rowsPerPage={params.count}
      rowsPerPageOptions={[10]}
      count={props.groupTotal}
      page={params.page}
      handlePagination={(payload) => {
        const newParams = { ...params, count: payload.count, page: payload.page };

        groupSearchAction(searchKey, newParams);
      }}
    />
  );

  return (
    <React.Fragment>
      {props.isMulti && !props.dialogNoChildren && header}
      <div className={classes.search}>
        {searchBar}
      </div>
      <Box className={classes.container}>
        <div className={classes.list}>
          {list}
        </div>
        <div>
          {paginator}
        </div>
      </Box>
    </React.Fragment>
  );
};

GroupListSelector.propTypes = {
  classes: PropTypes.object,
  customTexts: PropTypes.object,
  isLoading: PropTypes.bool,
  isMulti: PropTypes.bool,
  dialogNoChildren: PropTypes.bool,

  groups: PropTypes.array,
  groupTotal: PropTypes.number,
  queryScopes: PropTypes.arrayOf(PropTypes.oneOfType([PropTypes.string, PropTypes.array])),
  dialogQueryScopes: PropTypes.arrayOf(PropTypes.oneOfType([PropTypes.string, PropTypes.array])),
  inputCallback: PropTypes.func,
  getGroupsBegin: PropTypes.func,

  parentData: PropTypes.object,
  setParentData: PropTypes.func,
  displayParentUI: PropTypes.bool,
  setDisplayParentUI: PropTypes.func,
  isDisplayingChildren: PropTypes.bool,
  handleParentExpand: PropTypes.func,
  handleFinishExitTransition: PropTypes.func,

  open: PropTypes.bool,
  addGroup: PropTypes.func.isRequired,
  removeGroup: PropTypes.func.isRequired,
  isSelected: PropTypes.func.isRequired,
  selected: PropTypes.oneOfType([
    PropTypes.arrayOf(PropTypes.object),
    PropTypes.object,
    PropTypes.string, // When it's a single item select and there's no value
  ]),

  intl: intlShape.isRequired,
};

GroupListSelector.defaultProps = {
  queryScopes: [],
  dialogQueryScopes: ['all_parents'],
};

export default compose(
  injectIntl,
  memo,
  withStyles(styles)
)(GroupListSelector);
