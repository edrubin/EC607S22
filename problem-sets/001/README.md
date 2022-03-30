# Problem set 001

## Data

**README!** The data in this problem set come from three sources—all of which I downloaded from [NHGIS](https://nhgis.org).

1. the 1860 US Census
2. the 2010 US Census
3. the American Community Survey (ACS), 2006-2010

The table below describes each variable in the dataset.

The data look at the potential for modern effects of historical slavery in the United States—focusing on ten states that (unsuccessfully) attempted to secede (South Carolina, Mississippi, Florida, Alabama, Georgia, Louisiana, Texas, Virginia, North Carolina, and Tennessee). Each of these states was a "slave state" in 1860, *i.e.*, they allowed Black enslavement. In 1860, the population of enslaved people varied across the counties of these ten states.

| Name | Description (Source) |
|:---|:---|
| `state` | State name |
| `county` | County name |
| `gisjoin` | Code for GIS joining |
| `pop_enslaved_1860` | County population of enslaved persons in 1860 (Census) |
| `pop_total_1860` | County population in 1860 (Census) |
| `pop_total_2010` | County population in 2010 (Census) |
| `pop_black_2010` | County black population in 2010 (Census) |
| `pop_white_2010` | County white population in 2010 (Census) |
| `income_black_2010` | County median income for Black households 2006-2010 (ACS) |
| `income_white_2010` | County median income for White households 2006-2010 (ACS) |
| `pct_pop_enslaved_1860` | Percent of county population enslaved in 1860 (Census) |
| `had_rosenwald_school` | Indicator variable: Did the county have a Rosenwald school? (Mazumder) |

## Goal

This problem set has three purposes: 

- refresh the topics you learned in previous metrics course
- refresh/build/strengthen your `R` abilities
- start building your intuition about causality within econometrics/regression.

## Questions

**01** Load whichever packages you think you'll want—and the dataset [`data-001.csv`](https://raw.githack.com/edrubin/EC607S22/master/problem-sets/001/data-001.csv).

**02** Using the function `lm()`: Regress counties' median income for Black household in 2010 (`income_black_2010`) on an intercept, the county's 1860 enslaved population (`pop_enslaved_1860`), the county's total population in 1860 (`pop_total_1860`), and the county's total population in 2010 (`pop_total_2010`). (You should have one outcome variable, and intercept, and three explanatory variables.)

Report your estimates an interpret the coefficient on `pop_enslaved_1860`.

**03** Now run the *same* regression specified in **02** but using only matrix algebra (don't use `lm()` or any other pre-build regression functions). Don't worry about estimating the standard errors (for now).

*Hint:* The functions `matrix()` and `as.matrix()` can help you create matrices. The functions `t()` and `solve()` take the transpose and inverse of matrices (respectively).

**04** Write a function that 

- accepts two arguments: `y` and `X` (both matrices)
- outputs estimated coefficients

Show that your function works.

*Hint:* The function named `function()` allows you to write a function. For example, 

```{r}
function(a,b) {
  a + b
}
```

accepts two arguments (`a` and `b`) and outputs their sum.

**05** Add standard errors to your function. Again, you should estimate these standard errors with matrix algebra (not regression functions built by someone else).

Show that your function works.

**06** What assumptions do your standard errors rely upon (to be approximately correct)?

**07** What assumptions do your coefficient estimates need to be causal?

**Extra credit** Re-write your function (or write a new function) so that it accepts three arguments: 

- `var_y`: the **name** of the outcome variable
- `var_x`: the **names** of the explanatory variables
- `data`: the dataset (as you would pass it to `lm()`)

and outputs estimated linear-regression coefficients and their standard errors.

Show that your function works.
